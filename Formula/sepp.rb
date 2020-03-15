class Sepp < Formula
  include Language::Python::Virtualenv

  desc "Ensemble of HMM methods (SEPP, TIPP, UPP)"
  homepage "https://github.com/smirarab/sepp"
  url "https://github.com/smirarab/sepp/archive/4.3.10.tar.gz"
  sha256 "24d8d410138563017e6f2f1263d5e34427f5bbddb875b72a036f7c879cef203b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "45b005e6beaadc6a631d11f4f32301b55beda6c2a41222a59e96cdb271ee5814" => :mojave
    sha256 "b81115b45f3c8075931cbf0fefef35a9357f1ff8878353c6a2f45ad8bb7234db" => :x86_64_linux
  end

  depends_on :java
  depends_on "python"

  resource "DendroPy" do
    url "https://files.pythonhosted.org/packages/f5/21/17e4fbb1c2a68421eec43930b1e118660c7483229f1b28ba4402e8856884/DendroPy-4.4.0.tar.gz"
    sha256 "f0a0e2ce78b3ed213d6c1791332d57778b7f63d602430c1548a5d822acf2799c"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("DendroPy")

    # Create a config file, but fix up the paths for a relocatable install
    system "python3", "setup.py", "config", "-c"

    # sepp installs bundled binaries, move these since buildpath != prefix
    libexec.install ".sepp"

    # Don't version dependencies to avoid changing postinstall on updates
    bundle = Dir[libexec/".sepp/bundled-*"][0]
    ohai "Relocating bundled binaries from #{bundle}"
    mv bundle, libexec/".sepp/bundled"

    # Point sepp to the right libexec install location
    rm buildpath/"home.path"
    (buildpath/"home.path").write libexec/".sepp"

    venv.pip_install_and_link buildpath

    # home.path is installed to libexec in the last step, but for some
    # inscrutable reason it needs to go into site-packages
    mv libexec/"home.path", libexec/Language::Python.site_packages/"home.path"

    # Install test data
    pkgshare.install Dir[buildpath/"test/unittest/data/mock/*"]
  end

  def post_install
    config = libexec/".sepp/main.config"
    ohai "Rewriting #{config}"
    rm config
    config.write <<~EOS
      [pplacer]
      path=#{libexec}/.sepp/bundled/pplacer
      [hmmalign]
      path=#{libexec}/.sepp/bundled/hmmalign
      [hmmsearch]
      path=#{libexec}/.sepp/bundled/hmmsearch
      piped=False
      elim=10000
      filters=True
      [hmmbuild]
      path=#{libexec}/.sepp/bundled/hmmbuild
      [jsonmerger]
      path=#{libexec}/.sepp/bundled/seppJsonMerger.jar
      [exhaustive]
      strategy = centroid
      minsubsetsize = 2
      placementminsubsetsizefacotr = 4
      placer = pplacer
      weight_placement_by_alignment = True
    EOS
  end

  test do
    cp_r opt_pkgshare/"pyrg", testpath
    cd "pyrg" do
      system "#{bin}/run_sepp.py",
             "-t=sate.tre",
             "-r=sate.tre.RAxML_info",
             "-a=sate.fasta",
             "-f=pyrg.even.fas",
             "-x=2"
    end
  end
end
