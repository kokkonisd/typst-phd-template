// Replace 0.2.0 with the version of the template you've installed.
#import "@local/phd-template:0.2.0" as template


#show: doc => template.presentation_setup(
    doc,
    title: "My Cool Presentation",
    title_short: "Cool Presentation",
    subtitle: "It's Really Interesting, I Swear",
    authors: (
        (
            name: "It's Me",
            organization: "My Lab",
            email: "me@mylab.com",
        ),
    ),
    authors_short: (
        "I. Me",
    ),
)


#template.slide(title: "Overview", size: 30pt)[
    - Introduction
    - Some Stuff
    - Conclusion
]


#template.section_slide(title: "Introduction", subtitle: "where I introduce stuff")

#template.slide(title: "Background (1/2)")[
    #lorem(100)
]

#template.slide(title: "Background (2/2)")[
    #lorem(50)
]


#template.section_slide(title: "Some Stuff", subtitle: "That's Interesting")

#template.slide(title: "Primary stuff")[
    - One
    - Two
    - Three
]

#template.slide(title: "Secondary stuff")[
    - Four
        - Four Point Five
    - Five
]


#template.section_slide(title: "Conclusion", subtitle: "wrapping it up")

#template.slide(title: "What I Learned")[
    - nothing
]


#template.section_slide(title: "Thank you for your attention :)", subtitle: "Any questions?")
