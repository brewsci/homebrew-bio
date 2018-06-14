class Gaemr < Formula
  desc "Genome Assembly Evaluation, Metrics and Reporting"
  homepage "https://www.broadinstitute.org/software/gaemr/"

  url "https://www.broadinstitute.org/software/gaemr/wp-content/uploads/2012/12/GAEMR-1.0.1.tar.gz"
  sha256 "cab1818e33b8ce9db2b25268206d73b5883f6c40843c258a72daba79e841d70a"
  revision 1

  def install
    libexec.install Dir["*"]
    bin.install_symlink "../libexec/bin/GAEMR.py"
  end

  def caveats; <<~EOS
    After install GAEMR, you must do these 3 things:

    1. Amend your UNIX PATH environmental variable to point to your
       installation of the GAEMR/bin directory:
       export PATH=#{libexec}/bin:$PATH
    2. Amend your UNIX PYTHONPATH environmental variable to point to
       your installation of the GAEMR directory:
       export PYTHONPATH=#{libexec}:$PYTHONPATH
    3. Change the path variables in
       #{libexec}/gaemr/PlatformConstant.py
       to reflect your installation for the various bioinformatics tools.
    EOS
  end

  test do
    assert_match "Usage", shell_output("PYTHONPATH=#{libexec} #{bin}/GAEMR.py --help")
  end
end
