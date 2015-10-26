requires "List::Util" => "0";
requires "Moose::Role" => "0";
requires "WWW::Sitemap::XML" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Catalyst" => "0";
  requires "Catalyst::Controller" => "0";
  requires "Catalyst::Test" => "0";
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::More" => "0";
  requires "lib" => "0";
  requires "parent" => "0";
  requires "perl" => "5.006";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::More" => "0.96";
  requires "Test::Vars" => "0";
};
