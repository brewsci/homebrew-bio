class Slim < Formula
  # cite Haller_2019: "https://doi.org/10.1093/molbev/msy228"
  desc "Forward simulator for population genetics and evolutionary biology"
  homepage "https://messerlab.org/slim/"
  url "https://github.com/MesserLab/SLiM/archive/v3.5.tar.gz"
  sha256 "7f6f9b33416d0f5a6ab4e004f8f2cb5251b57ae270da7f4b3054b2135765a376"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f33ea710cb58c11264d0dd99598076466d5b3933c631de0a59be0650e1046f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03a4ae3d6ab3dd077833d196938cb9f1fe0258b102f2c3f800b7f326993ef0d0"
  end

  depends_on "cmake" => :build

  def install
    mkdir "SLiM_build" do
      system "cmake", "-DCMAKE_BUILD_TYPE=Release", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/slim", "-testEidos"
    system "#{bin}/slim", "-testSLiM"
  end
end
