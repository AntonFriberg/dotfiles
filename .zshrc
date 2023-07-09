
# Workaround since chsh -s is not persisted on company laptop
# Set preferred shell to fish if it exists
preferred_shell=
fish_path="$(which fish)"
if [ -x "$fish_path" ]; then
  preferred_shell="$fish_path"
fi
# Change to preferred shell if zsh started in interactive mode
if [ -n "$preferred_shell" ]; then
  case $- in
    *i*) SHELL=$preferred_shell; export SHELL; exec "$preferred_shell";;
  esac
fi
