class Mummer < Formula
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mummer/mummer/3.23/MUMmer3.23.tar.gz"
  sha256 "1efad4f7d8cee0d8eaebb320a2d63745bb3a160bb513a15ef7af46f330af662f"
  revision 2
  # cite "https://doi.org/10.1186/gb-2004-5-2-r12"

  depends_on "tcsh" unless OS.mac?

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
      next if ["gaps", "nucmer2xfig"].include?(tool)
      # mummerplot is broken with recent versions of Perl.
      next if tool == "mummerplot" && OS.linux?
      assert_match /U(sage|SAGE)/, pipe_output("#{prefix}/#{tool} -h 2>&1")
    end
  end
end
