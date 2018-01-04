source("lib/deps.R")

set.seed(1)

all.results <- data.frame()

err <- mad
epsilons <- c(0.01)
epsilon <- 1.0

for (epsilon.index in 1:length(epsilons)) {
    epsilon <- epsilons[epsilon.index]
    for (condition in c(0, 1, 2, 3, 4)) { # here i eliminated the 5
        data <- load.data(condition)      # here it does 100 CV, one for each condition and model

        N <- 100                          # nº of CV (100)
        proportion <- 0.75                # proportion used for training 

        baseline.results <- cross.validate(
            baseline.fit.function,
            baseline.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        DRIFT.results <- cross.validate(
            DRIFT.fit.function,
            DRIFT.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        ITCH.results <- cross.validate(
            ITCH.fit.function,
            ITCH.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        tradeoff.results <- cross.validate(
            tradeoff.fit.function,
            tradeoff.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        exponential.results <- cross.validate(
            exponential.fit.function,
            exponential.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        homothetic.exponential.results <- cross.validate(
            homothetic.exponential.fit.function,
            homothetic.exponential.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        hyperbolic.results <- cross.validate(
            hyperbolic.fit.function,
            hyperbolic.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        homothetic.hyperbolic.results <- cross.validate(
            homothetic.hyperbolic.fit.function,
            homothetic.hyperbolic.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        quasihyperbolic.results <- cross.validate(
            quasihyperbolic.fit.function,
            quasihyperbolic.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        )

        homothetic.quasihyperbolic.results <- cross.validate(
            homothetic.quasihyperbolic.fit.function,
            homothetic.quasihyperbolic.test.function,
            data,
            proportion,
            epsilon,
            err,
            N
        ) # Aqui los marca

        baseline.results <- transform(baseline.results, Model="Baseline")

        DRIFT.results <- transform(DRIFT.results, Model="DRIFT")

        ITCH.results <- transform(ITCH.results, Model="ITCH")

        tradeoff.results <- transform(tradeoff.results, Model="Tradeoff")

        exponential.results <- transform(
            exponential.results,
            Model="Exponential"
        )

        homothetic.exponential.results <- transform(
            homothetic.exponential.results,
            Model="Homothetic Exponential"
        )

        hyperbolic.results <- transform(
            hyperbolic.results,
            Model="Hyperbolic"
        )

        homothetic.hyperbolic.results <- transform(
            homothetic.hyperbolic.results,
            Model="Homothetic Hyperbolic"
        )

        quasihyperbolic.results <- transform(
            quasihyperbolic.results,
            Model="Quasi-Hyperbolic"
        )

        homothetic.quasihyperbolic.results <- transform(
            homothetic.quasihyperbolic.results,
            Model="Homothetic Quasi-Hyperbolic"
        )

        results <- rbind(                           # join all the Results
            exponential.results,
            hyperbolic.results,
            quasihyperbolic.results,
            tradeoff.results,
            DRIFT.results,
            ITCH.results
        )
                                                    # VERY INTRESTING GRAPH:
        ggplot(results, aes(x=Model, y=Error)) +
            stat_summary(fun.data="mean_cl_boot", geom="point") +
            stat_summary(fun.data="mean_cl_boot", geom="errorbar", size=0.2) +
            xlab("Model") +
            ylab("Mean Absolute Deviation under Cross-Validation") +
            ggtitle("") +
            theme_bw() +
            theme(legend.position="none")

        dir.create(
            file.path("graphs", "crossvalidated_comparisons"),
            recursive=TRUE,
            showWarnings=FALSE
        )

        ggsave(
            paste(
                "graphs/crossvalidated_comparisons/",
                "/model_comparisons",
                condition,
                ".pdf",
                sep=""
            )
        )

        results <- rbind(
            baseline.results,
            exponential.results,
            homothetic.exponential.results,
            hyperbolic.results,
            homothetic.hyperbolic.results,
            quasihyperbolic.results,
            homothetic.quasihyperbolic.results,
            tradeoff.results,
            DRIFT.results,
            ITCH.results
        )

        all.results <- rbind(all.results, cbind(condition, results))
    }
}


dir.create("output", recursive=TRUE, showWarnings=FALSE)

write.csv(
    all.results,
    file=file.path("output", "all_results.csv"),
    row.names=FALSE
)

predictive.power <- function(df) {
    res <- NULL

    try(res <- t.test(df$Error))

    if (is.null(res)) {
        return(
            data.frame(
                MeanError=mean(df$Error),
                LowerBoundError=mean(df$Error),
                UpperBoundError=mean(df$Error)
            )
        )
    } else {
        return(
            data.frame(
                MeanError=mean(df$Error),         #Here it picks the two limints of the 
                LowerBoundError=res$conf.int[1],  #confidence interval
                UpperBoundError=res$conf.int[2]
            )
        )
    }
}

total.results <- ddply(
    all.results,
    c("condition", "Model"),
    predictive.power
)

names(total.results) <- c(
    "Condition",
    "Model",
    "MeanError",
    "LowerBoundError",
    "UpperBoundError"
)

total.results <- transform(        #Here it calculates the standard error
    total.results,
    SEM=(UpperBoundError - LowerBoundError) / 2
)

write.csv(
    total.results,
    file=file.path("output", "crossvalidated_results.csv"),
    row.names=FALSE
)

total.results <- transform(
    total.results,
    ErrorSummary=paste(
        MeanError,
        paste("+/-", (UpperBoundError - LowerBoundError) / 2) #standart error
    )
)

options(digits=6)

print(cast(total.results, Condition ~ Model, value="ErrorSummary"))
print(cast(total.results, Condition ~ Model, value="MeanError"))

all.results <- transform(all.results, Form=factor(condition))

levels(all.results$Form) <- c(
  "Pooled",
  "Delay $, Gain Framing",
  "Speedup $, Gain Framing",
  #    "Standard MEL",
  "Delay $, Loss Framing",
  "Speedup $, Loss Framing")
# Graph used on the paper, created by us:
ggplot(
  subset(all.results,all.results$Model==c("Exponential","Hyperbolic",
                                          "Quasi-Hyperbolic","DRIFT", "ITCH")),
  aes(x=Model, y=Error, group=Model, color=Model, shape=Model)) +
  stat_summary(fun.data="mean_cl_boot", geom="point", size=2.5) +
  stat_summary(fun.data="mean_cl_boot", geom="errorbar", size=0.3) +
  xlab("Model") +
  ylab("Mean Absolute Deviation under Cross-Validation") +
  facet_grid(~Form,scales='free')+
  ggtitle("") +
  theme_bw() +
  theme(axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank())
ggsave(
    "graphs/crossvalidated_comparisons/model_comparisons.pdf",
    height=4,
    width=10
)
