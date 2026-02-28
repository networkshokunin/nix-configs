#NOTE(starter): this is the most basic way to set up this user with their core home manager settings
# In this case, because the host is the ISO, very little is needed for the user.
{ ... }:
{
  imports = [
    common/core
  ];
}
