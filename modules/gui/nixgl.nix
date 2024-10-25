{
  nixGL,
  pkgs,
  ...
}: {
  nixGL = {
    packages = nixGL.packages; # you must set this or everything will be a noop
    defaultWrapper = "mesa"; # choose from options
  };
}
