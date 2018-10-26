class Mummer < Formula
  # cite Kurtz_2004: "https://doi.org/10.1186/gb-2004-5-2-r12"
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"
  revision 3

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2642a41271e0a4d0522c3d1890d1dfc6ced4ad03aa90ba31c37210f0a96a2e41" => :sierra
    sha256 "22df96cb1a3e421e5af2e432e3cfc10834ee13fa1e2916aae6a820dbcddcf8c5" => :x86_64_linux
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
