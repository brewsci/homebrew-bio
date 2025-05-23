class Rdock < Formula
  desc "Fast, versatile open source docking program for proteins and nucleic acids"
  homepage "https://rdock.github.io/"
  url "https://github.com/CBDD/rdock/archive/refs/tags/v24.04.204-legacy.tar.gz"
  sha256 "cf5bf35d60254ae74c45f0c5ed3050513bbc8ae8df9c665157eb26f6b5a33d16"
  license "LGPL-3.0-only"
  head "https://github.com/CBDD/rdock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "d9810213a0f5a454a7955eb63900d52928646e8ad4572b116f41d6edd2f4edc4"
    sha256 cellar: :any,                 arm64_sonoma:  "0270a31c6083b9d0efe62428405c82aa323ae351c1901f867602620f5367238a"
    sha256                               ventura:       "f904b8567ae0543cfe62dbbd2b3edbe8ce9265572e5dcba715527858c779779e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12a1c46c9fe86e1e5ccc8422bf8976e6c9b03649a9dadb87b18fa994fd3b4ca8"
  end

  depends_on "gcc" => :build
  depends_on "numpy"
  depends_on "perl"
  depends_on "popt"
  depends_on "pytest"
  depends_on "python"

  patch do
    url "https://raw.githubusercontent.com/eunos-1128/rDock/66f167d73cbfd5be64eda2ee1ff295ce5c7d3b3f/NMObjective.h.patch"
    sha256 "5633b36c6a5e9f74a3855afd3e05ac9e3c7a588471e7f16ac508736ab093b6f7"
  end

  def install
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-14"

    inreplace "Makefile" do |s|
      s.gsub!(/INCLUDE\s*:=/, "INCLUDE := -I#{Formula["popt"].opt_include} ")
      s.gsub!(/LIB_DEPENDENCIES\s*:=\s*-lpopt/, "LIB_DEPENDENCIES := -L#{Formula["popt"].opt_lib} -lpopt")
    end

    ENV["CXX_EXTRA_FLAGS"] = "-I#{Formula["popt"].opt_include}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["gcc"].opt_lib}/gcc/14" if OS.mac?
    (share/"lib").mkpath
    cp_r Dir["lib/*"], share/"lib"
    rm Dir["lib/*"]
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    cp_r "data", share
  end

  def caveats
    <<~EOS
      Before running rDock programs, you need to set the `RBT_ROOT` environment variable:
        export RBT_ROOT=#{share}
    EOS
  end

  test do
    # TODO: Update later
    system "#{bin}/rbdock", "--help"
  end
end
