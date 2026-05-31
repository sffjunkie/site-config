{
  imports = [
    ./host
  ];

  config.home-manager.users.sysadmin = import ./home;
}
