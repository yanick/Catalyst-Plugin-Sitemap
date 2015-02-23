requires "List::Util" => "0";
requires "Moose::Role" => "0";
requires "WWW::Sitemap::XML" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Catalyst" => "0";
  requires "Catalyst::Controller" => "0";
  requires "Catalyst::Test" => "0";
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::More" => "0.88";
  requires "lib" => "0";
  requires "parent" => "0";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "version" => "0.9901";
};
