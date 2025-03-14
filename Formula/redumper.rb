class Redumper < Formula
  desc "Low level CD dumper utility"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/build_503.tar.gz"
  sha256 "62116a9f295e260fedfcb433e50b5e3d100a7c27a2a8df3e25fc1b6f398db8c1"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    cmake_args = %w[
      -G Ninja
      -DREDUMPER_CLANG_USE_LIBCPP=ON
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
