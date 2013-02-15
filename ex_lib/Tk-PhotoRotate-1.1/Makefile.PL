
use Tk::MMutil;

Tk::MMutil::TkExtMakefile(
    NAME          => "Tk::PhotoRotate",
    DISTNAME      => "Tk-PhotoRotate",
    VERSION_FROM  => "Tk/PhotoRotate.pm",
    PM            => {"Tk/PhotoRotate.pm" => "\$(INST_LIBDIR)/PhotoRotate.pm", "Tk/PhotoRotateSimple.pm" => "\$(INST_LIBDIR)/PhotoRotateSimple.pm"},
    dist          => {COMPRESS => 'gzip', SUFFIX => 'gz'},
    ABSTRACT      => 'Rotate Photos at arbitrary angles',
    AUTHOR        => 'Steve Lidie (sol0@lehigh.edu)',
);
