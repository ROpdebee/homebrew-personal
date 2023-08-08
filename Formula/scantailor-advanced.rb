class ScantailorAdvanced < Formula
  desc "Interactive post-processing tool for scanned pages"
  homepage "https://github.com/ScanTailor-Advanced/scantailor-advanced"
  url "https://github.com/ScanTailor-Advanced/scantailor-advanced/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "db41c3a1ba0ecfc00a40a4efe2bcc9d2abb71ecb77fdc873ae6553b07a228370"
  license "GPL-3.0-only"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "qt6"
  depends_on "zlib"

  def install
    # Patch for Qt 6.4+ support, which removes inherited QObject include from QString.h
    inreplace "src/core/Utils.h", "#include <QString>", "#include <QString>\n#include <QObject>"

    # Turn off portable build, otherwise it installs its config in the brewed installation dir.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DPORTABLE_VERSION=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # App writes its config to $HOME/.config, but only when the config is changed
    # or on interactive shut down. It doesn't do so when it's killed with a SIGTERM
    # or SIGINT.
    begin
      pid = fork do
        system "#{bin}/scantailor"
      end
      sleep 1
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
