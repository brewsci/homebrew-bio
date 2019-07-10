class Bioperl < Formula
  # cite Stajich_2002: "https://doi.org/10.1101/gr.361602"
  desc "Open source Perl tools for bioinformatics, genomics and life science"
  homepage "https://bioperl.org"
  url "https://cpan.metacpan.org/authors/id/C/CJ/CJFIELDS/BioPerl-1.007002.tar.gz"
  sha256 "17aa3aaab2f381bbcaffdc370002eaf28f2c341b538068d6586b2276a76464a1"
  revision 3

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "36b08831cc85e3550ee622b3d1c485f6bf9d2dcfd87ef9a9c33ba72f9bae8f94" => :sierra
    sha256 "7a3a5d0a2179fe45c2d407f13bac0d5c484e2d80639a094baa353167ab4abf9d" => :x86_64_linux
  end

  depends_on "cpanminus" => :build
  depends_on "perl" unless OS.mac?

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "DBI" unless OS.mac?
    system "cpanm", "--self-contained", "-l", libexec, "."
    bin.env_script_all_files libexec, "PERL5LIB" => ENV["PERL5LIB"]
    Dir[libexec/"bin/bp_*.pl"].each do |executable|
      name = File.basename executable
      (bin/name).write_env_script executable, :PERL5LIB => ENV["PERL5LIB"]
    end
  end

  test do
    tests = %w[
      bp_biogetseq.pl bp_classify_hits_kingdom.pl bp_composite_LD.pl
      bp_dbsplit.pl bp_download_query_genbank.pl bp_fastam9_to_table.pl
      bp_fetch.pl bp_filter_search.pl bp_find-blast-matches.pl bp_flanks.pl
      bp_heterogeneity_test.pl bp_hmmer_to_table.pl bp_index.pl
      bp_local_taxonomydb_query.pl bp_mask_by_search.pl bp_mrtrans.pl
      bp_mutate.pl bp_nexus2nh.pl bp_nrdb.pl bp_oligo_count.pl
      bp_parse_hmmsearch.pl bp_query_entrez_taxa.pl bp_remote_blast.pl
      bp_search2alnblocks.pl bp_search2gff.pl bp_search2table.pl
      bp_search2tribe.pl bp_seq_length.pl bp_seqcut.pl bp_seqpart.pl
      bp_seqretsplit.pl bp_split_seq.pl bp_sreformat.pl bp_translate_seq.pl
      bp_tree2pag.pl bp_unflatten_seq.pl
    ]
    tests.each do |executable|
      assert_match /Usage|usage|NAME|Unknown option|Can't open -h/, shell_output("#{executable} -h </dev/null 2>&1")
    end
  end
end
