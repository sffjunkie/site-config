{ config, ... }:
{
  config = {
    sops.templates."api_key_conf" = {
      mode = "0444";
      content = ''
        OWM_API_KEY=${config.sops.placeholder."owm"}
      '';
    };

    sops.templates."location_conf" = {
      mode = "0444";
      content = ''
        USER_LOCATION_LATITUDE=${config.sops.placeholder."location/latitude"}
        USER_LOCATION_LONGITUDE=${config.sops.placeholder."location/longitude"}
      '';
    };

    environment.etc = {
      "environment.d/20-api_key.conf".source = config.sops.templates."api_key_conf".path;
      "environment.d/20-location.conf".source = config.sops.templates."location_conf".path;
    };
  };
}
