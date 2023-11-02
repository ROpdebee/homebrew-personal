class MypaintBrushesAT1 < Formula
  desc "Brushes used by MyPaint and other software using libmypaint"
  homepage "https://github.com/mypaint/mypaint-brushes/tree/v1.3.x"
  url "https://github.com/mypaint/mypaint-brushes/releases/download/v1.3.1/mypaint-brushes-1.3.1.tar.xz"
  sha256 "fef66ffc241b7c5cd29e9c518e933c739618cb51c4ed4d745bf648a1afc3fe70"
  license "CC0-1.0"

  keg_only "conflicts with mypaint-brushes"

  depends_on "libmypaint@1.4"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_predicate share.glob("mypaint-data/*/brushes/classic/marker_small_prev.png").first, :exist?
  end
end
