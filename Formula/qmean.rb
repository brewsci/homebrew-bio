class Qmean < Formula
  desc "Protein model quality estimation tool (QMEAN)"
  homepage "https://git.scicore.unibas.ch/schwede/QMEAN"
  url "https://git.scicore.unibas.ch/schwede/QMEAN/-/archive/4.3.1/qmean-4.3.1.tar.gz"
  sha256 "01a8b89e41bde00c35ae19d263bbd53df5591319281c0a5f6654a989e56a2ee4"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/openstructure"
  depends_on "numpy"
  depends_on "python-matplotlib"
  depends_on "python@3.13"
  depends_on "scipy"

  def install
    mkdir "build" do
      system "cmake", "..",
        "-DOPTIMIZE=1",
        "-DOST_ROOT=#{Formula["openstructure"].opt_prefix}",
        *std_cmake_args
      system "make"
      system "make", "check"
      system "make", "install"
    end

    # install helper scripts
    pkgshare.install Dir["docker/**/*"]
    bin.install_symlink pkgshare/"docker/run_qmean.py" => "qmean"
    prefix.install_metafiles
  end

  test do
    # simple invocation
    output = shell_output("#{bin}/qmean --version")
    assert_match "qmean-4.3.0", output
  end
end
