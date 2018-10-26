class Mothur < Formula
  # cite Schloss_2009: "https://doi.org/10.1128/AEM.01541-09"
  desc "16s analysis software"
  homepage "https://www.mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.40.3.tar.gz"
  sha256 "7237e763b046ade1034bf39e3e76ee0256013b1d50103330f0177c3b0cb876f7"
  head "https://github.com/mothur/mothur.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "59b2e018b90cbf65048a9f3954199cf7f2fe0fce86bef48d43162de42d256ebb" => :sierra
    sha256 "7f275e00b23e454358d58805e36969eae3b990f02fdba8a21c853bab77e3382b" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "readline" unless OS.mac?

  def install
    # Reduce memory usage for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    boost = Formula["boost"]
    inreplace "Makefile", '"\"Enter_your_boost_library_path_here\""', boost.opt_lib
    inreplace "Makefile", '"\"Enter_your_boost_include_path_here\""', boost.opt_include
    system "make"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
