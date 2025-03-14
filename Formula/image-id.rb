class ImageId < Formula
  desc "Compute the MusicBrainz disc id from a CD image"
  homepage "https://www.kepstin.ca/projects/image-id/"
  url "https://github.com/kepstin/image-id/releases/download/v2.1.0/image-id-2.1.0.tar.gz"
  sha256 "9ae16f4a938d351df5468e8d0ba732fde648dc4f1a1212e05d79ab312f8d7947"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/image-id-2.1.0"
    sha256 cellar: :any,                 ventura:      "73353a776856427d4791bc74e96566ef0bfb6971c4084352bd37fa65e8531019"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "807647562477c9b91998963013bc58deb388e3d226d56dfabf404f45483c4abc"
  end

  depends_on "pkg-config" => :build
  depends_on "libdiscid"
  depends_on "libmirage"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.wav")
    output = shell_output("#{bin}/image_id #{fixture}", 1)
    assert_match(output, "Cannot open image: Invalid number of channels in audio file")
  end
end
