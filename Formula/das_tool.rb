class DasTool < Formula
  # cite Sieber_2018: "https://doi.org/10.1038/s41564-018-0171-1"
  desc "Genomic binning refiner"
  homepage "https://github.com/cmks/DAS_Tool"
  url "https://github.com/cmks/DAS_Tool/archive/1.1.1.tar.gz"
  sha256 "2a55f67b5331251d8fd5adea867cc341363fbf7fa7ed5c3ce9c7679d8039f03a"
  revision 1
  head "https://github.com/cmks/DAS_Tool.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d10a3ffd28550e973e0403ee52628ab5c0369dd7b0c05c709e41dac732e20d51" => :sierra
    sha256 "af2c7b200ed174418e337ad5201ae7c53fac842925c4a876595b77730f0cad7c" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gettext"
  else
    depends_on "icu4c"
    depends_on "unzip" => :build
  end

  depends_on "diamond"
  depends_on "prodigal"
  depends_on "pullseq"
  depends_on "r"

  def install
    mkdir_p buildpath/"lib/R"
    ENV["R_LIBS_SITE"] = "#{buildpath}/lib/R"

    system "Rscript", "-e", "install.packages(c('ggplot2','doMC','data.table'),repos='https://cran.rstudio.com')"
    system "R", "CMD", "INSTALL", "./package/DASTool_1.1.1.tar.gz"

    system "unzip", "db.zip", "-d", "db"

    chmod 0755, "DAS_Tool"
    inreplace "DAS_Tool", "split --numeric-suffixes --lines=", "split -l " if OS.mac?
    inreplace "src/Fasta_to_Scaffolds2Bin.sh", "#!/bin/env bash", "#!/bin/bash"

    libexec.install "DAS_Tool", "src", "db", "lib"
    (bin/"DAS_Tool").write_env_script libexec/"DAS_Tool", :R_LIBS_SITE => libexec/"lib/R"
    ln_s libexec/"src/Fasta_to_Scaffolds2Bin.sh", bin/"Fasta_to_Scaffolds2Bin"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DAS_Tool -h", 1)
    assert_match "Usage", shell_output("#{bin}/Fasta_to_Scaffolds2Bin -h", 1)
  end
end
