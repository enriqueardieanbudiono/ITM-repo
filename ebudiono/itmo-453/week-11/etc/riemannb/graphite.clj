(ns examplecom.etc.graphite
    (:require [riemann.config :refer :all]
              [riemann.graphite :refer :all]))

(defn add-environment-to-graphite [event] (str "productionb.hosts.", (riemann.graphite/graphite-path-percentiles event)))

(def graph (async-queue! :graphite {:queue-size 1000}
            (graphite {:host "graphiteb" :path add-environment-to-graphite})))
