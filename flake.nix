{
  description = "basic setup for haskell/ghci";

  inputs = {
    nixpkgs-old.url = github:nixos/nixpkgs/be44bf67; # nixos-22.05 2022-10-15
    ## broken "strings"
    ## nixpkgs.url     = github:nixos/nixpkgs/bb92c02; # master 2023-08-12
    ## broken "strings"
    ## nixpkgs.url     = github:nixos/nixpkgs/b70e865; # nixos-23.05 2023-06-14
    nixpkgs.url     = github:nixos/nixpkgs/ea26cd3f; # nixos-23.05 2022-12-01
    flake-utils.url = github:numtide/flake-utils/c0e246b9;
    hpkgs1          = {
#       url    = github:sixears/hpkgs1/r0.0.17.0;
      url    = path:/home/martyn/src/hpkgs1;
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { self, nixpkgs, nixpkgs-old, flake-utils, hpkgs1 }:
    # many things don't work on, say, darwin
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hpkgs = hpkgs1.packages.${system};
        hlib  = hpkgs1.lib.${system};
      in
        rec {
          packages =
            flake-utils.lib.flattenTree (with pkgs; {
            inherit (hlib.hpkgs) cabal-install haskell-language-server;
            stylish-haskell =
              ##              hlib.hpkgs.haskellPackages.stylish-haskell_0_14_4_0;
              nixpkgs-old.legacyPackages.${system}.stylish-haskell;
            ghc = hlib.ghcWithHoogle (haskellPackages:
              builtins.attrValues hpkgs ++
              (with haskellPackages;
                     [
                       aeson ansi-wl-pprint base-unicode-symbols xmonad-contrib
                       # broken in nixpkgs as of 2021-08-18 5ebd941b75a8
                       # containers-unicode-symbols
##                       criterion data-default deepseq
##                       deepseq dhall diagrams Diff doctest exceptions filelock
##                       finite-typelits formatting freer genvalidity
##                       genvalidity-bytestring genvalidity-hspec
##                       genvalidity-property genvalidity-text ghc-typelits-extra
##                       hostaddress hostname http-client HUnit inflections keys
##                       lens ListLike logging-effect markdown-unlit monad-loops
##                       mono-traversable network-ip nonempty-containers
##                       optparse-applicative parsec parsers path pipes QuickCheck
##                       rainbow random range regex-applicative
##                       regex-pcre regex-with-pcre rio safe scientific shake
##                       shelly split streaming strings SVGFonts tagsoup tasty
##                       tasty-hspec tasty-hunit tasty-quickcheck
##                       temporary terminal-size text
##                       text-format text-icu th-lift-instances timers trifecta
##                       unordered-containers validity vector xmonad-contrib yaml

                       # currently broken in nix
                       # liquidhaskell
                       # lcs # doesn't build
                     ]
              ));
          });
        }
    );
}
