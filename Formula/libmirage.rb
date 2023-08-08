class Libmirage < Formula
  desc "CD-ROM image access library"
  homepage "https://cdemu.sourceforge.io/about/libmirage/"
  url "https://downloads.sourceforge.net/cdemu/libmirage-3.2.6.tar.xz"
  sha256 "257f4690c9195749ea936c4b44ada3e449b352dadaa107f31a1ed10f7b6df2a6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/libmirage-3.2.6"
    sha256 ventura:      "1da13744ae5936e8719a92fd8270aa21e34fc287fb7b6bfd45c92323c4d6a2b0"
    sha256 x86_64_linux: "f70d7b6a1f327b605de0afa211ab67a51abe0ae374cbdf2f15f5e2b64639d315"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "xz" # for lzma

  uses_from_macos "zlib"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    # Fix build errors with newer CMake
    inreplace_cmakelists = [
      "filters/filter-isz/CMakeLists.txt",
      "images/image-harddisk/CMakeLists.txt",
    ]
    inreplace inreplace_cmakelists, "_name} \"-undefined", "_name} PRIVATE \"-undefined"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
      "-DGTKDOC_ENABLED=OFF", "-DINTROSPECTION_ENABLED=ON", "-DPOST_INSTALL_HOOKS=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mirage/mirage.h>
      int main() {
        GError *error = NULL;

        mirage_initialize(&error);
        if (error) {
          exit(1);
        }
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libmirage").chomp.split
    system ENV.cc, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
