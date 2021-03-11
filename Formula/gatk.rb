class Gatk < Formula
  include Language::Python::Shebang

  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://software.broadinstitute.org/gatk"
  url "https://github.com/broadinstitute/gatk/releases/download/4.2.0.0/gatk-4.2.0.0.zip"
  sha256 "dd11cc8e3bc7a23c2c226366428f0908c902765eabbc1c641c736c06b80aaf78"
  license "BSD-3-Clause"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "e55337c2d7d735c6546bd03873dfc07bac3c3540c492315b7c20d22a2244c752"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4b4117555b904663ca90c00945cc29f7767742bb6c3a37078c0f077db52261d"
  end

  depends_on "openjdk"
  depends_on "python@3.9"

  resource "count_reads.bam" do
    url "https://github.com/broadinstitute/gatk/blob/626c88732c02b0fd5f395db20c91bf2784ec54b9/src/test/resources/org/broadinstitute/hellbender/tools/count_reads.bam?raw=true"
    sha256 "656e36331a39a3641565ef7810a529ac51270b4132007d7b94e6efff99133a2c"
  end

  def install
    prefix.install "gatk"
    prefix.install "scripts/dataproc-cluster-ui"
    prefix.install "gatk-package-#{version}-spark.jar"
    prefix.install "gatk-package-#{version}-local.jar"
    bash_completion.install "gatk-completion.sh"
    bins = ["#{prefix}/gatk", "#{prefix}/dataproc-cluster-ui"]
    bins.find { |f| rewrite_shebang detected_python_shebang, f }
    bin.install_symlink "#{prefix}/gatk"
    bin.install_symlink "#{prefix}/dataproc-cluster-ui"
  end

  def caveats
    <<~EOS
      This brew installation does not include the necessary python dependencies to run certain gatk tools.
      Similarly, it does not install the necessary version of R and its packages for certain plotting functions to work.

      See the GATK readme for detailed installation instructions.
         https://github.com/broadinstitute/gatk

      The recommended way of running the tools with complex python dependencies is to use the pre-built docker images instead of attempting to install them locally.
      Gatk dockers are available on docker hub:
         https://hub.docker.com/r/broadinstitute/gatk/tags/
    EOS
  end
  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1")
    testpath.install resource("count_reads.bam")
    assert_equal "Tool returned:\n8",
                  shell_output("#{bin}/gatk CountReads -I count_reads.bam --tmp-dir #{testpath}").strip
  end
end
