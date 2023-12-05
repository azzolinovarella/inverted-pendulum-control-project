function saveFig(fig, save_path)
    res = 300;
    pos = [1, 769, 1366, 674];  % Posicao da figura (tamanho q vai ser exportada -> fullscreen)
    fig.Position = pos;
    fontname(fig, 'LM Roman 12');  % Se quiser assegurar que fonte vai ser igual ao pdf
    
    exportgraphics(fig, save_path, 'Resolution', res)
end

