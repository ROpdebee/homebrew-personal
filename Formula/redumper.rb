class Redumper < Formula
  desc "Low level CD dumper utility"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/build_537.tar.gz"
  sha256 "555419fde088a2f7c54f6c41554a80bfcd5a2c96aa205f09d82312c20c8bf35a"
  license "GPL-3.0-or-later"

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
      -DREDUMPER_VERSION_BUILD=#{version}
    ]

    ENV["CXX"] = llvm.opt_bin/"clang++"

    # Patch sources to recognise our drive
    inreplace "drive.ixx",
      "\"BD-RE BH16NS55\"  , \"1.02\", \"N000200SIK92G9OF211\"",
      "\"BD-RE BH16NS55\"  , \"1.05\", \"N001601KL1O1JB1603\""

    # Patch sources to undo CD->Disc rename that causes incompatibility with MPF.
    # https://github.com/superg/redumper/commit/665a1b85d7e11f6d32ae3a1411df210a0f96468a
    inreplace "redumper.ixx", "options.command == \"disc\"", "options.command == \"cd\""

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
