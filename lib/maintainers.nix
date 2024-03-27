# Nixvim maintainers
#
# This attribute set contains Nixvim maintainers that do not
# have an entry in the Nixpkgs maintainer list. Entries are
# expected to follow the same format as that list.
#
# Nixpkgs maintainers: https://github.com/NixOS/nixpkgs/blob/0212bde005b3335b2665c1476c36b3936e113b15/maintainers/maintainer-list.nix
{
  alisonjenkins = {
    email = "alison.juliet.jenkins@gmail.com";
    github = "alisonjenkins";
    githubId = 1176328;
    name = "Alison Jenkins";
  };
  MattSturgeon = {
    email = "matt@sturgeon.me.uk";
    matrix = "@mattsturg:matrix.org";
    github = "MattSturgeon";
    githubId = 5046562;
    name = "Matt Sturgeon";
    keys = [
      {fingerprint = "7082 22EA 1808 E39A 83AC  8B18 4F91 844C ED1A 8299";}
    ];
  };
  DanielLaing = {
    email = "daniel@daniellaing.com";
    matrix = "@bodleum:matrix.org";
    github = "Bodleum";
    githubId = 60107449;
    name = "Daniel Laing";
    keys = [
      {fingerprint = "0821 8B96 DC73 85E5 BB7C  A535 D264 3BD2 13BC 0FA8";}
    ];
  };
}
