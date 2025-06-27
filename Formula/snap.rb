class Snap < Formula
  # cite Korf_2004: "https://doi.org/10.1186/1471-2105-5-59"
  desc "Gene prediction tool"
  homepage "http://korflab.ucdavis.edu/software.html"
  url "http://korflab.ucdavis.edu/Software/snap-2013-11-29.tar.gz"
  sha256 "e2a236392d718376356fa743aa49a987aeacd660c6979cee67121e23aeffc66a"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "5e856b94be598ccbe6f40d0e18c7d8a3be24b428cf9f48f9f621a2899d2aa5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1719060198b0c7937b4a01eac3783262bfea23b240952c15b3d46320251322af"
  end

  def install
    system "make"
    bin.install %w[exonpairs fathom forge hmm-info snap]
    bin.install Dir["*.pl"]
    bin.env_script_all_files libexec, ZOE: opt_prefix
    prefix.install %w[DNA HMM Zoe 00README LICENSE example.zff]
  end

  test do
    assert_match "command line", shell_output("#{bin}/snap -help")
  end
end
