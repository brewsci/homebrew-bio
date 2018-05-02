class Humann2 < Formula
  # cite Abubucker_2012: "https://doi.org/10.1371/journal.pcbi.1002358"
  desc "HUMAnN2: The HMP Unified Metabolic Analysis Network"
  homepage "https://huttenhower.sph.harvard.edu/humann"

  url "https://bitbucket.org/biobakery/humann2/get/0.11.1.tar.bz2"
  sha256 "c84e98a486b995ad9a934f06d9ffd180d36e768d01b366ada98e31011510011a"

  depends_on "bowtie2"
  depends_on "diamond"
  depends_on "metaphlan"
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *(Language::Python.setup_install_args(libexec) + ["--bypass-dependencies-install"])
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system "#{bin}/humann2", "--version"
  end
end
