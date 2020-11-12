class DasTool < Formula
  # cite Sieber_2018: "https://doi.org/10.1038/s41564-018-0171-1"
  desc "Genomic binning refiner"
  homepage "https://github.com/cmks/DAS_Tool"
  url "https://github.com/cmks/DAS_Tool/archive/1.1.2.tar.gz"
  sha256 "0cb13aadb8727a7a1fd08b25336d59f742f6a6384a8bff894cb79b6a5661c613"
  head "https://github.com/cmks/DAS_Tool.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "af7fc1d026f60d560b6e6ec396e8e71a64d26688d1f92022c99c986db692a405" => :catalina
    sha256 "6485d66355c2354db7f21ca23869bb5715bdc9d8ee79aa64d5a3eb6c202b982a" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gettext"
  else
    depends_on "icu4c"
    depends_on "unzip" => :build
  end

  depends_on "brewsci/bio/pullseq"
  depends_on "diamond"
  depends_on "prodigal"
  depends_on "r"

  def install
    mkdir_p buildpath/"lib/R"
    ENV["R_LIBS_SITE"] = "#{buildpath}/lib/R"

    system "Rscript", "-e", "install.packages(c('ggplot2','doMC','data.table'),repos='https://cran.rstudio.com')"
    system "R", "CMD", "INSTALL", "./package/DASTool_#{version}.tar.gz"

    system "unzip", "db.zip", "-d", "db"

    libexec.install "DAS_Tool", "src", "db", "lib"
    (bin/"DAS_Tool").write_env_script libexec/"DAS_Tool", R_LIBS_SITE: libexec/"lib/R"
    ln_s libexec/"src/Fasta_to_Scaffolds2Bin.sh", bin/"Fasta_to_Scaffolds2Bin"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DAS_Tool -h", 1)
    assert_match "Usage", shell_output("#{bin}/Fasta_to_Scaffolds2Bin -h", 1)
  end
end
