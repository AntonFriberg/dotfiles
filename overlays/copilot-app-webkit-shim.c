// LD_PRELOAD shim for github-copilot-app's WebKitGTK web views:
// - disable smooth scrolling for every web view whose settings the host
//   application fetches (wry/Tauri does so for each web view);
// - ignore the app's own WEBKIT_DMABUF_RENDERER_FORCE_SHM=1, which makes WebKit
//   copy every frame through CPU shared memory instead of zero-copy DMA-BUF.
//   A value already present in the launch environment is still honored.
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdlib.h>
#include <string.h>

typedef void *(*get_settings_fn)(void *);
typedef void (*set_smooth_scrolling_fn)(void *, int);
typedef int (*setenv_fn)(const char *, const char *, int);

int setenv(const char *name, const char *value, int overwrite) {
  static setenv_fn real_setenv;

  if (!real_setenv)
    real_setenv = (setenv_fn)dlsym(RTLD_NEXT, "setenv");
  if (name && strcmp(name, "WEBKIT_DMABUF_RENDERER_FORCE_SHM") == 0)
    return 0;
  return real_setenv(name, value, overwrite);
}

void *webkit_web_view_get_settings(void *web_view) {
  static get_settings_fn real_get_settings;
  static set_smooth_scrolling_fn set_smooth_scrolling;

  if (!real_get_settings)
    real_get_settings = (get_settings_fn)dlsym(RTLD_NEXT, "webkit_web_view_get_settings");
  if (!set_smooth_scrolling)
    set_smooth_scrolling = (set_smooth_scrolling_fn)dlsym(RTLD_DEFAULT, "webkit_settings_set_enable_smooth_scrolling");
  if (!real_get_settings)
    return NULL;

  void *settings = real_get_settings(web_view);
  if (settings && set_smooth_scrolling)
    set_smooth_scrolling(settings, 0);
  return settings;
}

// Remove this library from LD_PRELOAD so child processes (host git, ssh,
// shells) do not load a library built against Nix's glibc.
__attribute__((constructor)) static void drop_self_from_ld_preload(void) {
  Dl_info info;
  const char *preload = getenv("LD_PRELOAD");
  if (!preload || !dladdr((void *)drop_self_from_ld_preload, &info) || !info.dli_fname)
    return;

  char *copy = strdup(preload);
  char *kept = calloc(strlen(preload) + 1, 1);
  if (!copy || !kept) {
    free(copy);
    free(kept);
    return;
  }

  char *saveptr = NULL;
  for (char *entry = strtok_r(copy, ": ", &saveptr); entry; entry = strtok_r(NULL, ": ", &saveptr)) {
    if (strcmp(entry, info.dli_fname) == 0)
      continue;
    if (*kept)
      strcat(kept, ":");
    strcat(kept, entry);
  }

  if (*kept)
    setenv("LD_PRELOAD", kept, 1);
  else
    unsetenv("LD_PRELOAD");
  free(copy);
  free(kept);
}
