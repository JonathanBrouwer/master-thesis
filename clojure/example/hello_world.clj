(println (let [t (fn [T] (fn [e] e))] ((t "TYPE") true)))
