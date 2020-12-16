// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go time

// Package time provides functionality for measuring and displaying time.
//
// The calendrical calculations always assume a Gregorian calendar, with
// no leap seconds.
//
// Monotonic Clocks
//
// Operating systems provide both a “wall clock,” which is subject to
// changes for clock synchronization, and a “monotonic clock,” which is
// not. The general rule is that the wall clock is for telling time and
// the monotonic clock is for measuring time. Rather than split the API,
// in this package the Time returned by time.Now contains both a wall
// clock reading and a monotonic clock reading; later time-telling
// operations use the wall clock reading, but later time-measuring
// operations, specifically comparisons and subtractions, use the
// monotonic clock reading.
//
// For example, this code always computes a positive elapsed time of
// approximately 20 milliseconds, even if the wall clock is changed during
// the operation being timed:
//
// start := time.Now()
// ... operation that takes 20 milliseconds ...
// t := time.Now()
// elapsed := t.Sub(start)
//
// Other idioms, such as time.Since(start), time.Until(deadline), and
// time.Now().Before(deadline), are similarly robust against wall clock
// resets.
//
// The rest of this section gives the precise details of how operations
// use monotonic clocks, but understanding those details is not required
// to use this package.
//
// The Time returned by time.Now contains a monotonic clock reading.
// If Time t has a monotonic clock reading, t.Add adds the same duration to
// both the wall clock and monotonic clock readings to compute the result.
// Because t.AddDate(y, m, d), t.Round(d), and t.Truncate(d) are wall time
// computations, they always strip any monotonic clock reading from their results.
// Because t.In, t.Local, and t.UTC are used for their effect on the interpretation
// of the wall time, they also strip any monotonic clock reading from their results.
// The canonical way to strip a monotonic clock reading is to use t = t.Round(0).
//
// If Times t and u both contain monotonic clock readings, the operations
// t.After(u), t.Before(u), t.Equal(u), and t.Sub(u) are carried out
// using the monotonic clock readings alone, ignoring the wall clock
// readings. If either t or u contains no monotonic clock reading, these
// operations fall back to using the wall clock readings.
//
// On some systems the monotonic clock will stop if the computer goes to sleep.
// On such a system, t.Sub(u) may not accurately reflect the actual
// time that passed between t and u.
//
// Because the monotonic clock reading has no meaning outside
// the current process, the serialized forms generated by t.GobEncode,
// t.MarshalBinary, t.MarshalJSON, and t.MarshalText omit the monotonic
// clock reading, and t.Format provides no format for it. Similarly, the
// constructors time.Date, time.Parse, time.ParseInLocation, and time.Unix,
// as well as the unmarshalers t.GobDecode, t.UnmarshalBinary.
// t.UnmarshalJSON, and t.UnmarshalText always create times with
// no monotonic clock reading.
//
// Note that the Go == operator compares not just the time instant but
// also the Location and the monotonic clock reading. See the
// documentation for the Time type for a discussion of equality
// testing for Time values.
//
// For debugging, the result of t.String does include the monotonic
// clock reading if present. If t != u because of different monotonic clock readings,
// that difference will be visible when printing t.String() and u.String().
//
package time

// A Time represents an instant in time with nanosecond precision.
//
// Programs using times should typically store and pass them as values,
// not pointers. That is, time variables and struct fields should be of
// type time.Time, not *time.Time.
//
// A Time value can be used by multiple goroutines simultaneously except
// that the methods GobDecode, UnmarshalBinary, UnmarshalJSON and
// UnmarshalText are not concurrency-safe.
//
// Time instants can be compared using the Before, After, and Equal methods.
// The Sub method subtracts two instants, producing a Duration.
// The Add method adds a Time and a Duration, producing a Time.
//
// The zero value of type Time is January 1, year 1, 00:00:00.000000000 UTC.
// As this time is unlikely to come up in practice, the IsZero method gives
// a simple way of detecting a time that has not been initialized explicitly.
//
// Each Time has associated with it a Location, consulted when computing the
// presentation form of the time, such as in the Format, Hour, and Year methods.
// The methods Local, UTC, and In return a Time with a specific location.
// Changing the location in this way changes only the presentation; it does not
// change the instant in time being denoted and therefore does not affect the
// computations described in earlier paragraphs.
//
// Representations of a Time value saved by the GobEncode, MarshalBinary,
// MarshalJSON, and MarshalText methods store the Time.Location's offset, but not
// the location name. They therefore lose information about Daylight Saving Time.
//
// In addition to the required “wall clock” reading, a Time may contain an optional
// reading of the current process's monotonic clock, to provide additional precision
// for comparison or subtraction.
// See the “Monotonic Clocks” section in the package documentation for details.
//
// Note that the Go == operator compares not just the time instant but also the
// Location and the monotonic clock reading. Therefore, Time values should not
// be used as map or database keys without first guaranteeing that the
// identical Location has been set for all values, which can be achieved
// through use of the UTC or Local method, and that the monotonic clock reading
// has been stripped by setting t = t.Round(0). In general, prefer t.Equal(u)
// to t == u, since t.Equal uses the most accurate comparison available and
// correctly handles the case when only one of its arguments has a monotonic
// clock reading.
//
#Time: {
}

// A Month specifies a month of the year (January = 1, ...).
#Month: int // #enumMonth

#enumMonth:
	#January |
	#February |
	#March |
	#April |
	#May |
	#June |
	#July |
	#August |
	#September |
	#October |
	#November |
	#December

#January:   #Month & 1
#February:  #Month & 2
#March:     #Month & 3
#April:     #Month & 4
#May:       #Month & 5
#June:      #Month & 6
#July:      #Month & 7
#August:    #Month & 8
#September: #Month & 9
#October:   #Month & 10
#November:  #Month & 11
#December:  #Month & 12

// A Weekday specifies a day of the week (Sunday = 0, ...).
#Weekday: int // #enumWeekday

#enumWeekday:
	#Sunday |
	#Monday |
	#Tuesday |
	#Wednesday |
	#Thursday |
	#Friday |
	#Saturday

#Sunday:    #Weekday & 0
#Monday:    #Weekday & 1
#Tuesday:   #Weekday & 2
#Wednesday: #Weekday & 3
#Thursday:  #Weekday & 4
#Friday:    #Weekday & 5
#Saturday:  #Weekday & 6

// A Duration represents the elapsed time between two instants
// as an int64 nanosecond count. The representation limits the
// largest representable duration to approximately 290 years.
#Duration: int64 // #enumDuration

#enumDuration:
	_#minDuration |
	_#maxDuration |
	#Nanosecond |
	#Microsecond |
	#Millisecond |
	#Second |
	#Minute |
	#Hour

#Nanosecond:  #Duration & 1
#Microsecond: #Duration & 1000
#Millisecond: #Duration & 1000000
#Second:      #Duration & 1000000000
#Minute:      #Duration & 60000000000
#Hour:        #Duration & 3600000000000
