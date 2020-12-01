self: super: 

let
  stdenv = self.pkgs.stdenv;
  sha512 = {
    x86_64-linux =
      "eeee75323be762c329176d5856ec2ecfd16f06607965614df006730ed648a5b5d12ac7fd1942fe37cfc97e3013e796ef278e7c7bc4f32b8680585c4884a8a6a1";
    aarch64-linux =
      "03ea4cc342834a80f29b3b59ea1d7462e1814311dc6597bf2333359061b9b24f5ce98ed6ebf8d7ca05d42db31baba8ed8d4dec30a576fd818b3c0041c86d2937";
    x86_64-darwin =
      "b20865ce6c53b7f3321b4d18ccab52307183e4f1210215385870baaaa814d0ec57c8d41aca9a64b7edca4da1dec841f006e07f2af78dd68465a55ea9f25ca057";
  };
  url = {
    x86_64-linux =
      "https://download.visualstudio.microsoft.com/download/pr/c4b503d6-2f41-4908-b634-270a0a1dcfca/c5a20e42868a48a2cd1ae27cf038044c/dotnet-sdk-3.1.101-linux-x64.tar.gz";
    aarch64-linux =
      "https://download.visualstudio.microsoft.com/download/pr/cf54dd72-eab1-4f5c-ac1e-55e2a9006739/d66fc7e2d4ee6c709834dd31db23b743/dotnet-sdk-3.1.101-linux-arm64.tar.gz";
    x86_64-darwin =
      "https://download.visualstudio.microsoft.com/download/pr/515b77f4-4678-4b6f-a981-c48cf5607c5a/24b33941ba729ec421aa358fa452fd2f/dotnet-sdk-3.1.101-osx-x64.tar.gz";
  };
in {
  dotnet-sdk = super.dotnet-sdk.overrideAttrs (oldAttrs: rec {
    version = "3.1.101";
    src = super.fetchurl {
      url = url."${stdenv.hostPlatform.system}" or (throw
        "Missing url for host system: ${stdenv.hostPlatform.system}");
      sha512 = sha512."${stdenv.hostPlatform.system}" or (throw
        "Missing hash for host system: ${stdenv.hostPlatform.system}");
    };
  });
}