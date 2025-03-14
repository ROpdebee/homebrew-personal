class Isrcsubmit < Formula
  include Language::Python::Virtualenv

  desc "Extract ISRCs from audio CDs and submit them to MusicBrainz"
  homepage "https://jonnyjd.github.io/musicbrainz-isrcsubmit/"
  url "https://github.com/JonnyJD/musicbrainz-isrcsubmit.git",
    revision: "8f4c3b9f9b8f983443d58fba381baaa3a74edad7"
  version "3.0.0-dev"
  sha256 "fe1078e332b09d259b87fb15959a143916bd31b09a37a54917a35cfb0fe6b3d6"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/isrcsubmit-3.0.0-dev_1"
    sha256 cellar: :any_skip_relocation, ventura: "84e2ed371c4f7f4d98267e245de16203f865b935d43e009945833f0d94296527"
  end

  depends_on "keyring"
  depends_on "libdiscid"
  depends_on "python@3.13"

  resource "musicbrainzngs" do
    url "https://files.pythonhosted.org/packages/0a/67/3e74ae93d90ceeba72ed1a266dd3ca9abd625f315f0afd35f9b034acedd1/musicbrainzngs-0.7.1.tar.gz"
    sha256 "ab1c0100fd0b305852e65f2ed4113c6de12e68afd55186987b8ed97e0f98e627"
  end

  resource "discid" do
    url "https://files.pythonhosted.org/packages/d5/fa/c8856ae3eb53393445d84589afbd49ded85527563a7c0457f4e967d5b7af/discid-1.2.0.tar.gz"
    sha256 "cd9630bc53f5566df92819641040226e290b2047573f2c74a6e92b8eed9e86b9"
  end

  def install
    inreplace "setup.py", "isrcsubmit.py=isrcsubmit:main", "isrcsubmit=isrcsubmit:main"
    inreplace "isrcsubmit.py", "def main(argv):", "def main():\n    argv = sys.argv"
    inreplace "isrcsubmit.py", "=PIPE", "=PIPE, text=True"

    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.13")
    keyring = Formula["keyring"].opt_libexec
    (libexec/site_packages/"homebrew-keyring.pth").write keyring/site_packages
  end

  test do
    if OS.linux?
      assert_match "cannot open device", shell_output("#{bin}/isrcsubmit 2>&1", 1)
    else
      assert_match "could not find real device", shell_output("#{bin}/isrcsubmit 2>&1", 255)
    end
  end
end
