class Ps3dec < Formula
  desc "Decrypt and encrypt PS3 Redump ISOs"
  homepage "https://github.com/ROpdebee/ps3dec"
  url "https://github.com/ROpdebee/ps3dec.git",
    revision: "2f5ecbde9ec00a47bcae695b6d9994f92ce9c62b"
  version "0.2.0"
  license "MIT"

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/ps3dec-0.2.0"
    sha256 cellar: :any_skip_relocation, ventura: "615f0df7982c5b907b127ac46cca5544da88a40b45eb95d5abc61070f40714df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ps3dec", "--help"
  end
end
