use v6;

my %*SUB-MAIN-OPTS =
    :named-anywhere,
    :bundling;

enum Event (
    timesheet => 0b001,
    absence => 0b010,
    vacation => 0b100,
);

class Time {
	has Int $.hours = 0;
	has Int $.minutes = 0;
	has Int $.seconds is rw = 0;

	multi method new(Str $formatted) {
		die "Cannot parse time [$formatted]" unless 
			$formatted ~~ /	
				$<hours>=(<[0..9]>+)
				\: $<minutes>=(<[0..9]>+)
				\:? $<seconds>=(<[0..9]>+)?
			/;

		my $hours = in-range($<hours>.Int, :until => 25);
		my $minutes = in-range($<minutes>.Int, :until => 60);
		my $seconds = $<seconds>.defined ?? in-range($<seconds>.Int, :until => 60) !! 0;

		return self.bless(:$hours, :$minutes, :$seconds)
	}

	method at(Date $day) returns DateTime {
		return DateTime.new(
			date => $day, 
			hour => $.hours,
			minute => $.minutes,
			second => $.seconds,
		)
	}
}

sub in-range(Int $number, Int $until, --> Int) {
	unless 0 <= $number < $until {
		die "Number [$number] is not between 0 (inclusive) and $until (exclusive)"
	}

	$number
}

#|(Add timesheet)
multi MAIN(
        "rec",
        Event $event = timesheet,	#= The type of event
		Str :s($start),				#= The start of the event
        Str :e($end),				#= The end of the event
        Str :p($project),			#= The project (if it's a timesheet)
		Bool :d($atSameDay) = False,
) {
	my DateTime $start-time;

	if $atSameDay {	
		$start-time = Time.new($start).at(Date.today)
	} else {
		$start-time = DateTime.new($start)
	}

	CATCH {
		default { say "Cannot parse start time!" }
	}

	say "The $event starts at " ~ $start-time;
	say "For project $project" if $project.defined;
}








multi MAIN() {
	say "Running";
	
	for 1..5 {
		FIRST { say "Loop iteratino $_" }
		say "Iteration $_"
	}

	do-something("Henry");
	do-something(" 	  ")
}


sub do-something(Str $name) {
	say "jjjjjjjjjjjjjj";
	PRE { fail "name is bad" if is-blank($name) }
}

sub is-blank(Str $text, --> Bool) {
	if $text ~~ m/ \s* / {
		return True
	}

	return False
} 



constant $timesheet-file = "current_timesheet";

#|(Start to record new timesheet)
multi MAIN(
	"rec",
	"start"
) {
	my $fh = open $timesheet-file, :w;
	$fh.say("Recording");
	$fh.close;

	say 'Recording new timesheet'
}

#|(Stop to record new timesheet)
multi MAIN(
	"rec",
	"stop"
) {
	with read-time($timesheet-file) -> $start-time {
		say "Timesheet start was $start-time";
	} else {
		say "There is no timesheet to stop. \nPlease first start recording using: record start";
	}
}

sub read-time(Str $file) returns Str {
	fail "File does not exists" unless $file.IO.e;

	slurp $file;
}