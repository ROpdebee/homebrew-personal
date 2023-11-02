class LibmypaintAT14 < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.4.0/libmypaint-1.4.0.tar.xz"
  sha256 "59d13b14c6aca0497095f29ee7228ca2499a923ba8e1dd718a2f2ecb45a9cbff"
  license "ISC"

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/libmypaint@1.4-1.4.0"
    sha256 cellar: :any,                 ventura:      "39325569c1afb50f98dbcb13d82b1b3c6bb387380516f25067da278901d636d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53b83415fb20c9085dcf6f38d4d40d8c8d0e3454f3b97a9ca6572b61e86d230f"
  end

  keg_only "conflicts with libmypaint"

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--disable-introspection",
                          "--without-glib",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mypaint-brush.h>
      int main() {
        MyPaintBrush *brush = mypaint_brush_new();
        mypaint_brush_unref(brush);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libmypaint", "-L#{lib}", "-lmypaint", "-o", "test"
    system "./test"
  end
end
