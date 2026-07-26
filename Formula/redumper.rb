class Redumper < Formula
  desc "Low level CD dumper utility"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/b735.tar.gz"
  sha256 "8021434ac3e714bc81c32d6c74d9ecf789d7c2ba80fd776b1995ffdacb718317"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/redumper-503"
    sha256 cellar: :any_skip_relocation, ventura: "3d859114dd929bf0459962e062a50580a9c2dad1b1d680e3b3b4a213392ef89c"
  end

  depends_on "cmake" => :build
  depends_on "llvm@18" => :build
  depends_on "ninja" => :build

  resource "googletest" do
    url "https://github.com/google/googletest/archive/refs/tags/v1.15.2.tar.gz"
    sha256 "7b42b4d6ed48810c5362c265a17faebe90dc2373c885e5216439d37927f02926"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    resource("googletest").stage buildpath/"googletest-src"

    cmake_args = %W[
      -G Ninja
      -DREDUMPER_CLANG_USE_LIBCPP=ON
      -DREDUMPER_VERSION_BUILD=#{version}
      -DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=#{buildpath}/googletest-src
      -DLLVM_LIB_PATH=#{llvm.opt_lib}
    ]

    ENV["CXX"] = llvm.opt_bin/"clang++"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"redumper", "--help"
    assert_match "error: no ready drives detected on the system", shell_output("#{bin}/redumper disc 2>&1", 255)
  end
end
