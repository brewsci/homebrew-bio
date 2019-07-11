class Hmmer2 < Formula
  # cite Eddy_2009: "https://doi.org/10.1142/9781848165632_0019"
  # cite Johnson_2010: "https://doi.org/10.1186/1471-2105-11-431"
  # cite Eddy_2011: "https://doi.org/10.1371/journal.pcbi.1002195"
  desc "Profile HMM models for protein sequences"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.2.1.tar.gz"
  sha256 "a56129f9d786ec25265774519fc4e736bbc16e4076946dcbd7f2c16efc8e2b9c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7cbccc680a07e5421f3a582e5bf8d2c73c9a930b77823360e794aecf7928c51d" => :x86_64_linux
  end

  keg_only "hmmer2 conflicts with hmmer 3.x"

  # fast_algorithms.c:49:10: fatal error: 'ppc_intrinsics.h' file not found
  depends_on :linux

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--enable-threads", "--enable-lfs", "--disable-altivec"
    system "make"
    system "make", "install"
    pkgshare.install "tutorial", "testsuite"
  end

  test do
    assert_match "threshold", shell_output("#{bin}/hmmpfam 2>&1", 1)
  end
end
