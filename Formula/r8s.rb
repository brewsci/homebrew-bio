class R8s < Formula
  # cite Sanderson_2003: "https://doi.org/10.1093/bioinformatics/19.2.301"
  desc "Estimate rates and divergence times on phylogenetic trees"
  homepage "http://ceiba.biosci.arizona.edu/r8s/"
  url "https://downloads.sourceforge.net/project/r8s/r8s1.81.tar.gz"
  sha256 "9e89d7851d74d74487d147b77177a717e6c659b485c9b67f516340a6ed595080"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "471af1c1ebb7c44ac985fdcfb4e545440e9c6dbc978c84772eb084f1cdcad749" => :sierra
    sha256 "fb55772378ba1d0a41291c1cc58c2b5e892f749799920050fdab2dd5365803f2" => :x86_64_linux
  end

  depends_on "gcc" # for gfortran

  def install
    # Tell r8s where libgfortran is located
    obj_name = OS.linux? ? "libgfortran.so" : "libgfortran.dylib"
    fortran_lib = File.dirname `gfortran --print-file-name #{obj_name}`
    cd "src" do
      inreplace "makefile" do |s|
        s.change_make_var! "LPATH", "-L#{fortran_lib}"
        s.gsub! %r{/usr/include/\S+}, "" # get rid of makefile deps on system headers
      end
      system "make"
      bin.install "r8s"
    end
    pkgshare.install Dir["examples", "*.pdf"]
  end

  test do
    assert_match "r8s version #{version}", shell_output("#{bin}/r8s -v -b", 1)
  end
end
