class Mpf < Formula
  desc "Redumper/Aaru/DiscImageCreator GUI in C#"
  homepage "https://github.com/SabreTools/MPF"
  url "https://github.com/SabreTools/MPF/archive/refs/tags/3.3.0.tar.gz"
  sha256 "ffa128efe46f69cdb8b71f59471ac9c8620793f24961af6e0ca983b624ab02e7"
  license "GPL-3.0-or-later"

  depends_on "dotnet" => :build
  depends_on "brotli"

  def install
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --self-contained
      --output #{bin}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
      -p:Version=#{version}
      -p:PublishSingleFile=true
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "MPF.CLI/MPF.CLI.csproj", *args
  end

  test do
    assert_match "bdrom - BD-ROM", shell_output("#{bin}/MPF.CLI --listmedia 2>&1")
  end
end
