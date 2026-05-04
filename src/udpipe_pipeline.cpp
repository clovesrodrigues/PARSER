#include "udpipe_pipeline.hpp"

#include <sstream>

namespace paser {

Sentence UDPipePipeline::analyze_text(const std::string& text) const {
    (void)config_;
    // Placeholder: tokenização simples por espaço até integrar udpipe.h/libudpipe.a.
    Sentence sentence;
    std::istringstream iss(text);
    std::string w;
    std::size_t idx = 1;
    while (iss >> w) {
        Token tk;
        tk.id = idx++;
        tk.form = w;
        tk.lemma = w;
        tk.upos = "X";
        tk.xpos = "_";
        tk.feats = "_";
        tk.head = 0;
        tk.deprel = "dep";
        sentence.tokens.push_back(std::move(tk));
    }
    return sentence;
}

} // namespace paser
