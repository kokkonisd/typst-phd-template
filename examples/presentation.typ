// Replace 0.2.3 with the version of the template you've installed.
#import "@local/phd-template:0.2.3" as template


#show: doc => template.presentation-setup(
    doc,
    title: "My Cool Presentation",
    title-short: "Cool Presentation",
    subtitle: "It's Really Interesting, I Swear",
    authors: (
        (
            name: "It's Me",
            organization: "My Lab",
            email: "me@mylab.com",
        ),
    ),
    authors-short: (
        "I. Me",
    ),
)


#template.slide(title: "Overview", size: 30pt)[
    - Introduction
    - Some Stuff
    - Conclusion
]


#template.section-slide(title: "Introduction", subtitle: "where I introduce stuff")

#template.slide(title: "Background (1/2)")[
    #lorem(100)
]

#template.slide(title: "Background (2/2)")[
    #lorem(50)
]


#template.section-slide(title: "Some Stuff", subtitle: "That's Interesting")

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


#template.section-slide(title: "Conclusion", subtitle: "wrapping it up")

#template.slide(title: "What I Learned")[
    - nothing
]


#template.section-slide(title: "Thank you for your attention :)", subtitle: "Any questions?")
