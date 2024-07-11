class Muscle < Formula
  # cite Edgar_2004: "https://doi.org/10.1186/1471-2105-5-113"
  # cite Edgar_2022: "https://doi.org/10.1038/s41467-022-34630-w"
  desc "Multiple sequence alignment program"
  homepage "https://www.drive5.com/muscle/"
  url "https://github.com/rcedgar/muscle/archive/refs/tags/5.1.0.tar.gz"
  sha256 "2bba8b06e3ccabf6465fa26f459763b2029d7e7b9596881063e3aaba60d9e87d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "facb165df0b74683682971e5570332a1dcb111720f853fb3ecae4de63509c3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb3bd2fc6f97b35f5427dbbe75aa8dc8fefc6bc49566f000d669004c641cde8e"
  end

  depends_on "libomp" if OS.mac?

  def install
    cd "src" do
      # Use clang++ instead of g++-11
      inreplace "Makefile", "g++-11", "clang++"
      # libomp is used for OpenMP support
      # -std=c++11 is needed for clang
      inreplace "Makefile", "-fopenmp", "-L#{Formula["libomp"].opt_lib} -lomp -std=c++11" if OS.mac?
      system "make"
      if OS.mac?
        bin.install "Darwin/muscle"
      else
        bin.install "Linux/muscle"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle -version")
  end
end
