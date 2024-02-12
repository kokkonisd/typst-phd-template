// Replace 0.2.0 with the version of the template you've installed.
#import "@local/phd-template:0.2.0" as template


#show: doc => template.report_setup(
    doc,
    title: "Annual thesis report",
    subtitle: "Very interesting and long title of the thesis",
    subtitle_size: 20pt,
    date: datetime(day: 23, month: 04, year: 2025),
    authors: (
        (
            (
                group: "Myself",
                members: (
                    (
                        name: "It's Me",
                        organization: "My Lab",
                        email: "me@mylab.com",
                    ),
                )
            ),
        ),
    ),
    signature: "Signature of someone important idk",
    bibliography: bibliography("dummy.bib"),
)


= Introduction

#lorem(100)

#lorem(100)

#lorem(100)



= Background

As some people smarter than me have found @Turing2009,
#lorem(100)

#lorem(100)

#lorem(100)


= Contributions

== Theorectical

#lorem(100)

== Technical

#lorem(100)


= Conclusion

#lorem(100)
