{ config, lib, ... }:
{
  config.var = {
    hostname = "athena";
    username = "alex";

    # Upgrade/GC opt-ins
    autoUpgrade = false;
    autoGarbageCollector = true;

    # NixOS config directory
    configDirectory = "/home/" + config.var.username + "/.config/nixos";

    # Git config
    git = {
      username = "Abolkin";
      email = "syaka.abolkin@gmail.com";
    };

    # Locale & Keyboard
    location = "Moscow";
    timeZone = "Moscow/Europe";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "ru_RU.UTF-8";
    keyboardLayout = "us,ru";
  };

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
