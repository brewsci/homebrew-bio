class Mummer < Formula
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"
  revision 3
  # cite "https://doi.org/10.1186/gb-2004-5-2-r12"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "08eb9012c2e9466b8945c9bdd6d4397d5ad70b025c102f5a2de1dcbff5175755" => :sierra_or_later
    sha256 "14086ae0f8420cc5d322f5ccfe614d418a2eb4bdd5304126881a66cc7b33f35b" => :x86_64_linux
  end

  depends_on "tcsh" unless OS.mac?

  # Fix the error: Can't use 'defined(%hash)'
  patch do
    url "https://gist.githubusercontent.com/sjackman/a531ee6866e6dcd89aaec37eaa60d5f4/raw/0d3f0146f1d9154913fee0564c6468c49efdc391/mummerplot.diff"
    sha256 "9b1a3619ec1a2f91c5141c275dd6ddcc4788dbce0835697402cd6e8d006f4c2a"
  end

  TOOLS = %w[
    annotate combineMUMs delta-filter dnadiff exact-tandems gaps mapview mgaps
    mummer mummerplot nucmer nucmer2xfig promer repeat-match
    run-mummer1 run-mummer3 show-aligns show-coords show-diff show-snps show-tiling
  ].freeze

  def install
    prefix.install Dir["*"]
    cd prefix do
      system "make"
      rm_r "src"
    end
    TOOLS.each { |tool| bin.install_symlink prefix/tool }
    mv bin/"annotate", bin/"annotate-mummer"
  end

  test do
    TOOLS.each do |tool|
      # Skip two tools that do not have a help flag
      next if ["gaps", "nucmer2xfig"].include? tool
      assert_match /U(sage|SAGE)/, pipe_output("#{prefix}/#{tool} -h 2>&1")
    end
  end
end
