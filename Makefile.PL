#======================================================================
# Makefile Maker for LaTeXML::Plugin::Doc - LaTeXML Doc post-processor
# [emails]
#======================================================================
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'LaTeXML::Plugin::Odt',
  AUTHOR => 'Lukas Kohlhase <email>',
  ABSTRACT => "LaTeXML::Plugin::Doc - A LaTeXML post-processor for Word and OpenOffice",
  VERSION => '0.1',
  PREREQ_PM => {
    'LaTeXML' => '0.7.99',
  },
  test => {TESTS => 't/*.t'},
  (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
    'meta-spec' => { version => 2 },
      resources => {
        repository => {
          type => 'git',
          url => 'https://github.com/KWARC/LaTeXML-Plugin-Doc.git',
          web => 'https://github.com/KWARC/LaTeXML-Plugin-Doc',
        }}})
  : ()),
);
