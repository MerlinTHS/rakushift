use v6;

my %*SUB-MAIN-OPTS =
    :named-anywhere,
    :bundling;

enum Event (
    timesheet => 0b001,
    absence => 0b010,
    vacation => 0b100,
);

constant $timesheetFile = "current_timesheet";

#|(Add timesheet)
multi MAIN(
        "record",
        Event $event = timesheet,	#= The type of event
        Str :s($start),			#= The start of the event
        Str :e($end),			#= The end of the event
        Str :p($project),		#= The project (if it's a timesheet)
) {
    say "Recording $event from '$start' to '$end' for project $project!"
}

#|(Start to record new timesheet)
multi MAIN(
	"record",
	"start"
) {
	my $fh = open $timesheetFile, :w;
	$fh.say("Recording");
	$fh.close;

	say 'Recording new timesheet'
}

#|(Stop to record new timesheet)
multi MAIN(
	"record",
	"stop"
) {
	with readTime($timesheetFile) -> $startTime {
		say "Timesheet start was $startTime";
	} else {
		say "There is no timesheet to stop. \nPlease first start recording using: record start";
	}
}

sub readTime(Str $file) returns Str {
	fail "File does not exists" unless $file.IO.e;

	slurp $file;
	
}
