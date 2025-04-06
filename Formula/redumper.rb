class Redumper < Formula
  desc "Low level CD dumper utility"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/build_438.tar.gz"
  sha256 "fbbe780275175800eb42f7032c988fa9a99d726008c8222c6e6a900bf9ce6fdd"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/ROpdebee/homebrew-personal/releases/download/redumper-537"
    sha256 cellar: :any_skip_relocation, ventura: "c32f93f39ecf0688ee91c37c889704d54753ae95c36b4ae8f9fa0abd91f6cedf"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    cmake_args = %W[
      -G Ninja
      -DREDUMPER_CLANG_USE_LIBCPP=ON
      -DREDUMPER_CLANG_LINK_OPTIONS=""
      -DREDUMPER_VERSION_BUILD=#{version}
    ]

    ENV["CXX"] = llvm.opt_bin/"clang++"

    # Patch sources to recognise our drive
    inreplace "drive.ixx",
      "\"BD-RE BH16NS55\"  , \"1.02\", \"N000200SIK92G9OF211\"",
      "\"BD-RE BH16NS55\"  , \"1.05\", \"N001601KL1O1JB1603\""

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"redumper", "--help"
    assert_match "error: no ready drives detected on the system", shell_output("#{bin}/redumper cd 2>&1", 255)
  end
end
