{
  runCommand,
  callPackage,
  template,
}:
runCommand "user-configs.md"
  {
    inherit template;
    user_configs = callPackage ../../../docs/user-configs { };
  }
  ''
    substitute $template $out \
      --subst-var-by USER_CONFIGS "$(cat $user_configs)"
  ''
