class Ps3dec < Formula
  desc "Decrypt and encrypt PS3 Redump ISOs"
  homepage "https://github.com/ROpdebee/ps3dec"
  url "https://github.com/ROpdebee/ps3dec.git",
    revision: "2f5ecbde9ec00a47bcae695b6d9994f92ce9c62b"
  version "0.2.0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ps3dec", "--help"
  end
end
